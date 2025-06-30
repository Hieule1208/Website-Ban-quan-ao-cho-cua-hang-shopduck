<%@page import="java.util.List"%>
<%@page import="data.giohang"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Giỏ hàng</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #fefefe;
            color: #333;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            color: #ff6f61;
            margin-top: 30px;
        }

        table {
            width: 90%;
            max-width: 1000px;
            margin: 30px auto;
            border-collapse: collapse;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }

        th, td {
            border: 1px solid #ddd;
            padding: 14px;
            text-align: center;
        }

        th {
            background-color: #ffe5e0;
            color: #333;
            font-weight: 600;
        }

        td {
            background-color: #fff;
        }

        .quantity-input {
            width: 60px;
            text-align: center;
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .actions form {
            display: inline-block;
        }

        .actions button {
            padding: 6px 12px;
            background-color: #ff6f61;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: background-color 0.3s ease;
        }

        .actions button:hover {
            background-color: #e65b4e;
        }

        .checkout-button {
            display: block;
            width: fit-content;
            margin: 30px auto 20px;
            padding: 15px 30px;
            background-color: #ff6f61;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1em;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .checkout-button:hover {
            background-color: #e65b4e;
        }

        .continue-shopping {
            text-align: center;
            margin: 30px auto 50px;
            font-size: 1em;
        }

        .continue-shopping a {
            color: #ff6f61;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .continue-shopping a:hover {
            color: #e65b4e;
            text-decoration: underline;
        }

        p {
            text-align: center;
            font-size: 1.1em;
        }

        strong {
            color: #333;
        }
    </style>
    <script>
        function formatCurrency(amount) {
            if (isNaN(amount) || amount === null || amount === undefined) return "0";
            let amountStr = String(Math.round(amount));
            let result = '';
            let count = 0;
            for (let i = amountStr.length - 1; i >= 0; i--) {
                result = amountStr[i] + result;
                count++;
                if (count % 3 === 0 && i !== 0) {
                    result = '.' + result;
                }
            }
            return result;
        }

        function updateOverallTotal() {
            let newOverallTotal = 0;
            const subtotalElements = document.querySelectorAll('.subtotal-display');
            subtotalElements.forEach(element => {
                const subtotalText = element.innerText.replace(' đ', '').replace(/\./g, '');
                const parsedSubtotal = parseFloat(subtotalText);
                if (!isNaN(parsedSubtotal)) newOverallTotal += parsedSubtotal;
            });
            const totalAmountSpan = document.getElementById('total-amount');
            if (totalAmountSpan) totalAmountSpan.innerText = formatCurrency(newOverallTotal) + " đ";
        }

        function updateQuantity(productId, inputElement) {
            const quantity = parseInt(inputElement.value);
            const row = inputElement.closest('tr');
            const priceElement = row.querySelector('.item-price');
            const price = parseFloat(priceElement.getAttribute('data-price'));
            let currentQuantity = quantity;
            if (isNaN(currentQuantity) || currentQuantity < 1) {
                inputElement.value = 1;
                currentQuantity = 1;
            }
            const subtotal = currentQuantity * price;
            const subtotalDisplay = row.querySelector('.subtotal-display');
            if (subtotalDisplay) {
                subtotalDisplay.innerText = formatCurrency(subtotal) + " đ";
            }
            updateOverallTotal();
            fetch('updateCart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: `productId=${productId}&quantity=${currentQuantity}`
            })
            .then(response => response.json())
            .then(data => {
                if (!data.success) {
                    console.error('Server error:', data.message);
                }
            })
            .catch(error => {
                console.error('AJAX error:', error);
            });
        }

        document.addEventListener('DOMContentLoaded', updateOverallTotal);
    </script>
</head>
<body>
    <h2>Giỏ hàng của bạn</h2>

    <%!
        // Helper method to format currency like JavaScript's formatCurrency
        String formatCurrencyVND(double amount) {
            if (Double.isNaN(amount) || amount == 0) return "0";
            String amountStr = String.valueOf(Math.round(amount));
            StringBuilder result = new StringBuilder();
            int count = 0;
            for (int i = amountStr.length() - 1; i >= 0; i--) {
                result.insert(0, amountStr.charAt(i));
                count++;
                if (count % 3 == 0 && i != 0) {
                    result.insert(0, '.');
                }
            }
            return result.toString();
        }
    %>

    <%
        List<giohang> cart = (List<giohang>) session.getAttribute("cart");
        String tenDangNhap = (String) session.getAttribute("tenDangNhap");
        if (cart == null || cart.isEmpty()) {
    %>
        <p>🛒 Giỏ hàng trống</p>
    <%
        } else {
            double total = 0;
    %>
        <table>
            <thead>
                <tr>
                    <th>Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Tổng phụ</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (giohang item : cart) {
                        double subtotal = item.getPrice() * item.getQuantity();
                        total += subtotal;
                %>
                <tr>
                    <td><%= item.getProductName() %></td>
                    <td class="item-price" data-price="<%= item.getPrice() %>">
                        <%= formatCurrencyVND(item.getPrice()) %> đ
                    </td>
                    <td>
                        <input type="number"
                               class="quantity-input"
                               name="quantity"
                               value="<%= item.getQuantity() %>"
                               min="1"
                               oninput="updateQuantity(<%= item.getProductId() %>, this)">
                    </td>
                    <td class="subtotal-display">
                        <%= formatCurrencyVND(subtotal) %> đ
                    </td>
                    <td class="actions">
                        <form action="RemoveFromCart" method="post">
                            <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                            <button type="submit">Xóa</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                %>
                <tr>
                    <td colspan="3" style="text-align:right;"><strong>Tổng cộng:</strong></td>
                    <td colspan="2" style="text-align:left;"><strong><span id="total-amount"><%= formatCurrencyVND(total) %> đ</span></strong></td>
                </tr>
            </tbody>
        </table>

        <% if (tenDangNhap == null) { %>
            <p style="color:red;">Vui lòng <a href="dangnhap.jsp">đăng nhập</a> để đặt hàng.</p>
        <% } else { %>
            <form action="thongtincanhan.jsp" method="get" style="text-align:center;">
                <button type="submit" class="checkout-button">Tiến hành thanh toán</button>
            </form>
        <% } %>
    <%
        }
    %>

    <div class="continue-shopping">
        <a href="trangchu.jsp">← Tiếp tục mua hàng</a>
    </div>
</body>
</html>