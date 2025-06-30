<%@page import="jakarta.servlet.http.HttpSession"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="Database.DBConnection" %>
<%@ page import="java.util.List" %>
<%@ page import="data.giohang" %>
<%@ page import="Xulythongtin.SessionManager" %>

<%
    List<giohang> cart = SessionManager.getCart(session);
    String errorMessage = null;

    if ("addToCart".equals(request.getParameter("action"))) {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT MaSP, TenSP, Gia, hinhanh, Soluong FROM SanPham WHERE MaSP = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String productName = rs.getString("TenSP");
                double price = rs.getDouble("Gia");
                String productImage = rs.getString("hinhanh");
                int stockQuantity = rs.getInt("Soluong");

                boolean productExists = false;
                for (giohang item : cart) {
                    if (item.getProductId() == productId) {
                        int newQuantity = item.getQuantity() + quantity;
                        if (newQuantity > stockQuantity) {
                            errorMessage = "Không thể thêm vào giỏ. Số lượng vượt quá tồn kho (" + stockQuantity + ").";
                        } else {
                            item.setQuantity(newQuantity);
                        }
                        productExists = true;
                        break;
                    }
                }

                if (!productExists) {
                    if (quantity > stockQuantity) {
                        errorMessage = "Không thể thêm vào giỏ. Số lượng vượt quá tồn kho (" + stockQuantity + ").";
                    } else {
                        cart.add(new giohang(productId, productName, price, quantity, productImage));
                    }
                }

                SessionManager.setCart(session, cart);

                if (errorMessage == null) {
                    response.sendRedirect("chitietsanpham.jsp?id=" + productId);
                    return;
                }
            } else {
                errorMessage = "Sản phẩm không tồn tại.";
            }
        } catch (Exception e) {
            errorMessage = "Lỗi: " + e.getMessage();
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <title>ShopDuck - Chi tiết sản phẩm</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f9f9f9;
            color: #333;
            padding: 20px;
            line-height: 1.6;
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

        .product-detail-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: flex-start;
            gap: 40px;
            max-width: 900px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .product-detail-image {
            flex: 1;
            min-width: 300px;
            text-align: center;
        }

        .product-detail-image img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        .product-detail-info {
            flex: 2;
            min-width: 300px;
        }

        .product-detail-info h2 {
            font-size: 2.2rem;
            color: #ff6f61;
            margin-bottom: 15px;
            border-bottom: 2px solid #ff6f61;
            padding-bottom: 10px;
        }

        .product-detail-info .price {
            font-size: 1.8rem;
            font-weight: bold;
            color: #e35a4e;
            margin-bottom: 20px;
        }

        .product-detail-info p {
            font-size: 1.1rem;
            margin-bottom: 15px;
        }

        .btn-add-to-cart {
            padding: 12px 25px;
            background: #ff6f61;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            font-size: 1.1rem;
            transition: background 0.3s ease, transform 0.2s ease;
            margin-top: 20px;
        }
        .btn-add-to-cart:hover {
            background: #e35a4e;
            transform: translateY(-2px);
        }

        footer {
            background: #333;
            color: #ddd;
            text-align: center;
            padding: 20px 0;
            font-size: 0.9rem;
            margin-top: 50px;
        }

        @media (max-width: 768px) {
            .product-detail-container {
                flex-direction: column;
                align-items: center;
                padding: 20px;
            }
            .product-detail-info h2 {
                font-size: 1.8rem;
                text-align: center;
            }
            .product-detail-info .price {
                font-size: 1.5rem;
                text-align: center;
            }
            .btn-add-to-cart {
                width: 100%;
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
            <a href="trangchu.jsp" style="margin-right: 20px;">Trang chủ</a>
            <a href="giohang.jsp" style="margin-right: 20px;">Giỏ hàng</a>
            <a href="thongtincanhan.jsp" style="margin-right: 20px;">Khách hàng</a>
            <% if (tenDangNhap == null) { %>
                <a href="dangnhap.jsp">Đăng nhập</a>
            <% } %>
        </nav>
    </div>
</header>

<main>
    <% if (errorMessage != null) { %>
        <div style="color: red; font-weight: bold; text-align: center; padding: 10px; border: 1px solid red; margin: 20px auto; max-width: 600px; background: #ffe6e6;">
            <%= errorMessage %>
        </div>
    <% } %>

    <%
        String idParam = request.getParameter("id");
        int productId = -1;
        if (idParam != null && !idParam.isEmpty()) {
            try {
                productId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                out.println("<p style='color: red; text-align: center;'>ID sản phẩm không hợp lệ.</p>");
            }
        }

        if (productId != -1) {
            ResultSet rs = null;
            try {
                Connection conn = DBConnection.getConnection();
                rs = DBConnection.getProductById(productId);

                if (rs.next()) {
    %>
                    <section class="product-detail-container">
                        <div class="product-detail-image">
                            <img src="<%= rs.getString("hinhanh") %>" alt="<%= rs.getString("TenSP") %>">
                        </div>
                        <div class="product-detail-info">
                            <h2><%= rs.getString("TenSP") %></h2>
                            <p class="price"><%= String.format("%,.0f", rs.getDouble("Gia")) %> đ</p>
                            <p><strong>Mô tả:</strong> <%= rs.getString("Mota") %></p>
                            <p><strong>Số lượng còn:</strong> <%= rs.getInt("Soluong") %></p>
                            <form action="chitietsanpham.jsp?id=<%= productId %>" method="post">
                                <input type="hidden" name="action" value="addToCart">
                                <input type="hidden" name="productId" value="<%= productId %>">
                                Số lượng: <input type="number" name="quantity" value="1" min="1"
                                max="<%= rs.getInt("Soluong") %>" 
                                style="width: 60px; padding: 8px 5px; border-radius: 5px; border: 1px solid #ccc; margin-right: 10px;">

                                <button type="submit" class="btn-add-to-cart">Thêm vào giỏ hàng</button>
                            </form>
                        </div>
                    </section>
    <%
                } else {
                    out.println("<p style='text-align: center; font-size: 1.2rem; color: #555;'>Không tìm thấy sản phẩm này.</p>");
                }
            } catch (SQLException e) {
                out.println("<p style='color: red; text-align: center;'>Lỗi truy vấn cơ sở dữ liệu: " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        } else {
            out.println("<p style='text-align: center; font-size: 1.2rem; color: #555;'>Vui lòng chọn một sản phẩm để xem chi tiết.</p>");
        }
    %>
</main>

<footer>
    <p>&copy; 2025 ShopDuck. Mọi quyền được bảo lưu.</p>
</footer>

</body>
</html>
