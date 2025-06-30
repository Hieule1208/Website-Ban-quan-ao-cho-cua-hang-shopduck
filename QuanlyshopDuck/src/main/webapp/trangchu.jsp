<%-- 
    Document   : trangchu
    Created on : May 19, 2025, 1:05:40 AM
    Author     : sphie
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="Database.DBConnection" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>ShopDuck - Sản phẩm</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f9f9f9;
            color: #333;
            padding: 20px;
        }

        header {
            background: #ff6f61;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
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

        h2 {
            color: #ff6f61;
            margin-bottom: 20px;
            border-bottom: 2px solid #ff6f61;
            display: inline-block;
            padding-bottom: 5px;
        }

        .product-container-wrapper {
            position: relative;
            max-width: 1100px;
            margin: 0 auto 50px;
        }

        .product-container {
            display: flex;
            overflow: hidden;
            transition: transform 0.4s ease;
        }

        .product-card {
            flex: 0 0 250px;
            margin-right: 25px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            text-align: center;
            text-decoration: none;
            color: inherit;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .product-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .product-card h2 {
            font-size: 1.2rem;
            margin: 10px 0;
            color: #333;
            border-bottom: none;
        }

        .product-card p {
            font-size: 1rem;
            margin: 5px 0;
            color: #ff6f61;
        }

        .product-card .price {
            font-weight: bold;
            color: #e35a4e;
            padding-bottom: 10px;
        }

        .btn-add {
            padding: 10px 20px;
            background: #ff6f61;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s ease;
            margin-bottom: 15px;
        }

        .btn-add:hover {
            background: #e35a4e;
        }

        .prev, .next {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 0, 0, 0.7);
            color: #fff;
            padding: 15px;
            border-radius: 50%;
            font-size: 20px;
            cursor: pointer;
            transition: background 0.3s;
            z-index: 10;
        }

        .prev:hover, .next:hover {
            background: #2ecc71;
        }

        .prev { left: 10px; }
        .next { right: 10px; }

        footer {
            background: #333;
            color: #ddd;
            text-align: center;
            padding: 20px 0;
            font-size: 0.9rem;
            margin-top: 50px;
        }

        @media (max-width: 600px) {
            nav a {
                margin-left: 15px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>

<header>
    <h1>🛍️ ShopDuck</h1>
    <%
        String tenDangNhap = (String) session.getAttribute("tenDangNhap");
    %>

    <% if (tenDangNhap != null) { %>
        <div style="background-color: #FF6F61; color: white; padding: 8px 20px; text-align: center; font-size: 15px;">
            Xin chào, <strong><%= tenDangNhap %></strong> |
            <a href="dangxuat.jsp" style="color: white; text-decoration: underline;">Đăng xuất</a>
        </div>
    <% } %>

    <div style="background-color: #FF6F61; color: white; padding: 10px 20px;">
        <nav>
            <a href="trangchu.jsp">Trang chủ</a>
            <a href="giohang.jsp">Giỏ hàng</a>
            <a href="thongtincanhan.jsp">Khách hàng</a>
            <% if (tenDangNhap == null) { %>
                <a href="dangnhap.jsp">Đăng nhập</a>
            <% } %>
        </nav>
    </div>
</header>

<main>
    <%
        Connection conn = null;
        Statement stmtCategories = null;
        Statement stmtProducts = null;
        ResultSet rsCategories = null;
        ResultSet rsProducts = null;
        try {
            conn = DBConnection.getConnection();
            stmtCategories = conn.createStatement();
            rsCategories = stmtCategories.executeQuery("SELECT iddanhmuc, tendanhmuc FROM danhmuc");
            while (rsCategories.next()) {
                int categoryId = rsCategories.getInt("iddanhmuc");
                String categoryName = rsCategories.getString("tendanhmuc");
    %>
                <h2><%= categoryName %></h2>
                <div class="product-container-wrapper">
                    <button class="prev">‹</button>
                    <button class="next">›</button>
                    <div class="product-container">
                        <%
                            stmtProducts = conn.createStatement();
                            rsProducts = stmtProducts.executeQuery("SELECT * FROM sanpham WHERE iddanhmuc = " + categoryId);
                            while (rsProducts.next()) {
                        %>
                            <a href="chitietsanpham.jsp?id=<%= rsProducts.getInt("MaSP") %>" class="product-card">
                                <img src="<%= rsProducts.getString("hinhanh") %>" alt="<%= rsProducts.getString("TenSP") %>">
                                <h2><%= rsProducts.getString("TenSP") %></h2>
                                <p class="price"><%= String.format("%,.0f", rsProducts.getDouble("Gia")) %> đ</p>
                                <button class="btn-add">Xem chi tiết</button>
                            </a>
                        <%
                            }
                            if (rsProducts != null) try { rsProducts.close(); } catch (SQLException e) {}
                            if (stmtProducts != null) try { stmtProducts.close(); } catch (SQLException e) {}
                        %>
                    </div>
                </div>
    <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p style='color: red;'>Lỗi khi tải danh mục hoặc sản phẩm: " + e.getMessage() + "</p>");
        } finally {
            if (rsCategories != null) try { rsCategories.close(); } catch (SQLException e) {}
            if (stmtCategories != null) try { stmtCategories.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
</main>

<footer>
    <p>© 2025 ShopDuck. Mọi quyền được bảo lưu.</p>
</footer>

<script>
document.querySelectorAll('.product-container-wrapper').forEach(wrapper => {
    const container = wrapper.querySelector('.product-container');
    const prevButton = wrapper.querySelector('.prev');
    const nextButton = wrapper.querySelector('.next');

    const scrollAmount = 280; // px mỗi lần trượt, tùy vào chiều rộng thẻ sản phẩm

    if (nextButton) {
        nextButton.addEventListener('click', () => {
            container.scrollBy({
                left: scrollAmount,
                behavior: 'smooth'
            });
        });
    }

    if (prevButton) {
        prevButton.addEventListener('click', () => {
            container.scrollBy({
                left: -scrollAmount,
                behavior: 'smooth'
            });
        });
    }
});
</script>


</body>
</html>
