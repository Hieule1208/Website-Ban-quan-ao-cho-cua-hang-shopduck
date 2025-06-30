<%-- 
    Document   : orderConfirmation
    Created on : Jun 1, 2025, 5:13:50 PM
    Author     : sphie
--%>

<%@page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Xác nhận đơn hàng</title>
    <style>
        /* Reuse styles from thongtincanhan.jsp */
    </style>
</head>
<body>
    <div class="container">
        <h2>Xác nhận đơn hàng</h2>
        <% String orderId = request.getAttribute("orderId") != null ? request.getAttribute("orderId").toString() : null;
           String message = (String) request.getAttribute("message");
           String error = (String) request.getAttribute("error");
           if (message != null) { %>
            <p class="message-success"><%= message %></p>
        <% } else if (error != null) { %>
            <p class="message-error"><%= error %></p>
        <% } %>
        <% if (orderId != null) { %>
            <div class="order-confirmation">
                <h3>Đơn hàng của bạn</h3>
                <p><strong>Mã đơn hàng:</strong> <%= orderId %></p>
            </div>
        <% } %>
        <a href="trangchu.jsp">Tiếp tục mua sắm</a>
    </div>
</body>
</html>